package com.example.tezster_wallet

import android.util.Log
import com.google.gson.Gson
import it.airgap.beaconsdk.blockchain.tezos.message.request.*
import it.airgap.beaconsdk.blockchain.tezos.message.response.*
import it.airgap.beaconsdk.blockchain.tezos.tezos
import it.airgap.beaconsdk.client.wallet.BeaconWalletClient
import it.airgap.beaconsdk.core.client.BeaconClient
import it.airgap.beaconsdk.core.data.*
import it.airgap.beaconsdk.core.message.*
import it.airgap.beaconsdk.transport.p2p.matrix.p2pMatrix
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*
import kotlin.concurrent.thread
import it.airgap.beaconsdk.blockchain.substrate.substrate
import it.airgap.beaconsdk.blockchain.tezos.data.TezosAccount
import it.airgap.beaconsdk.blockchain.tezos.data.TezosNetwork

typealias Callback = (msg: String) -> Unit

class BeaconPlugin(
    publicKeyHash: String
) {
    private var beaconClient: BeaconWalletClient? = null
    private var awaitingRequest: BeaconRequest? = null

    private var publicKeyHash: String? = null

    init {
        this.publicKeyHash = publicKeyHash
    }

    suspend fun startBeacon() {
        beaconClient = BeaconWalletClient("Naan") {
            support(substrate(), tezos())
            use(p2pMatrix())
        }
//        {
//            addConnections(P2P(p2pMatrix()),
//        )}
//        removePeers()
        checkForPeers()

        thread {
            runBlocking {
                beaconClient?.connect()
                    ?.onEach { result ->
                        result.getOrNull()?.let { saveAwaitingRequest(it) }
                    }
                    ?.collect {
//                        Log.i("Request", "Received $request")
                    }
            }
        }
    }


    fun respondExample(isGranted: Int, respondText: String, accountAddress: String) {
        val request = awaitingRequest ?: return
        val beaconClient = beaconClient ?: return

        val response = when (request) {
            is PermissionTezosRequest -> if (isGranted == 0) ErrorBeaconResponse.from(
                request,
                BeaconError.Aborted
            ) else
                PermissionTezosResponse.from(
                    request,
                    createTezosAccount(respondText, accountAddress, request.network, beaconClient)
                )
            is OperationTezosRequest -> if (isGranted == 0) ErrorBeaconResponse.from(
                request,
                BeaconError.Aborted
            ) else OperationTezosResponse.from(request, respondText)
            is SignPayloadTezosRequest -> SignPayloadTezosResponse.from(
                request,
                SigningType.Micheline,
                respondText
            )
            is BroadcastTezosRequest -> TODO()
            else -> TODO()
        }


        runBlocking {
            beaconClient?.respond(response)
            removeAwaitingRequest()
        }

    }

    private fun createTezosAccount(
        publicKey: String,
        accountAddress: String,
        network: TezosNetwork,
        client: BeaconClient<*>
    ): TezosAccount {
        return TezosAccount(publicKey, accountAddress, network, client)
    }

    fun pair(uri: String){
        GlobalScope.launch {
            try {
                beaconClient?.pair(uri);
            }catch (e:Exception){
                print(e);
            }
        }
    }

    fun addPeer(
        id: String,
        name: String,
        publicKey: String,
        relayServer: String,
        version: String
    ) {
        val peer = P2pPeer(
            id = id,
            name = name,
            publicKey = publicKey,
            relayServer = relayServer,
            version = version
        )
        Log.i("Data", "peer adding..")
        GlobalScope.launch {
            try {
                beaconClient?.addPeers(peer)
//            checkForPeers(
            } catch (e : Exception) {
                print(e.message)
            }
        }
        Log.i("Data", "peer adding after line..")
    }

    private fun checkForPeers() {
        val peers = runBlocking { beaconClient?.getPeers() }
//        Log.i("Peers", "peer added.." + peers.toString())

    }

    private fun removePeers() {
        runBlocking { beaconClient?.removeAllPeers() }
    }

    private fun saveAwaitingRequest(message: BeaconMessage) {
        awaitingRequest = if (message is BeaconRequest) message else null
        if (callback != null) callback!!(Gson().toJson(message))
    }

//    private fun getResultObject(message : BeaconMessage): Any{
//        if(message is PermissionBeaconRequest){
//            return
//        }
//        return "null";
//    }

    private fun removeAwaitingRequest() {
        awaitingRequest = null
    }

    companion object {

        var callback: Callback? = null

    }
}