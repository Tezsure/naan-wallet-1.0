import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:bs58check/bs58check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_singleton.dart';
import 'package:tezster_wallet/beacon/beacon_plugin.dart';

class DappWidget extends StatefulWidget {
  final HomePageController controller;

  DappWidget(this.controller);

  @override
  _DappWidgetState createState() => _DappWidgetState();
}

class _DappWidgetState extends State<DappWidget>
    with AutomaticKeepAliveClientMixin<DappWidget> {
  final GlobalKey webViewKey = GlobalKey();

  HomePageController controller;

  bool canGoBack, canGoForward;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        allowUniversalAccessFromFileURLs: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  PullToRefreshController pullToRefreshController;
  ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    canGoBack = false;
    canGoForward = false;
    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await controller.webViewController?.getSelectedText());
                await controller.webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await controller.webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          controller.webViewController?.reload();
        } else if (Platform.isIOS) {
          controller.webViewController?.loadUrl(
              urlRequest: URLRequest(
                  url: await controller.webViewController?.getUrl()));
        }
      },
    );
    setCanGoBackForward();
  }

  void setCanGoBackForward() async {
    canGoBack = await controller.webViewController?.canGoBack() ?? false;
    canGoForward = await controller.webViewController?.canGoForward() ?? false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      Container(
        height: 56,
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        color: Color(0xff1E1E1E),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  controller.webViewController?.goBack();
                });
                setCanGoBackForward();
              },
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  color: Color(0xff26282C),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: canGoBack ? Color(0xffFDFDFD) : Color(0xff616161),
                    size: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 4,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  controller.webViewController?.goForward();
                });
                setCanGoBackForward();
              },
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  color: Color(0xff26282C),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: canGoForward ? Color(0xffFDFDFD) : Color(0xff616161),
                    size: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 24,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1),
                  color: Color(0xff26282C),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 0,
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: false,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        controller: urlController,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                        onSubmitted: (value) {
                          var url = Uri.parse(value);
                          if (url.scheme.isEmpty) {
                            url = Uri.parse(
                                "https://www.google.com/search?q=" + value);
                          }
                          controller.webViewController
                              ?.loadUrl(urlRequest: URLRequest(url: url));
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          controller.webViewController?.reload();
                        });
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        child: Center(
                          child: Icon(
                            Icons.refresh,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  controller.webViewController?.loadUrl(
                      urlRequest: URLRequest(url: getDefaultUrl()
                          //  StorageSingleton().isFxHashFlow
                          //     ? Uri.parse(StorageSingleton().eventUri)
                          //     : Uri.parse(
                          //         'https://www.naanwallet.com/dapp.html',
                          //       ),
                          ));
                });
                setCanGoBackForward();
              },
              child: Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(
                  url: Uri.parse(widget.controller.lastVisitedUrlOnDapp)),
              // initialFile: "assets/index.html",
              initialUserScripts: UnmodifiableListView<UserScript>([]),
              initialOptions: options,

              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (webViewcontroller) {
                controller.webViewController = webViewcontroller;
              },

              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT,
                );
              },

              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url.toString();
                if (uri.startsWith('tezos://') || uri.startsWith('naan://')) {
                  uri = uri.substring(uri.indexOf("data=") + 5, uri.length);
                  try {
                    var data = String.fromCharCodes(base58.decode(uri));
                    if (!data.endsWith("}"))
                      data = data.substring(0, data.lastIndexOf('}') + 1);
                    var baseData = jsonDecode(data);
                    await BeaconPlugin.pair(baseData['name'], uri);
                    // await BeaconPlugin.addPeer(
                    //   baseData['id'],
                    //   baseData['name'],
                    //   baseData['publicKey'],
                    //   baseData['relayServer'],
                    //   baseData['version'] ?? "2",
                    // );
                  } catch (e) {}
                  return NavigationActionPolicy.CANCEL;
                }
                widget.controller.lastVisitedUrlOnDapp = uri;
                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onLoadError: (controller, url, code, message) {
                pullToRefreshController.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController.endRefreshing();
                  setCanGoBackForward();
                }
                setState(() {
                  this.progress = progress / 100;
                  urlController.text = this.url;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
            ),
            progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container(),
          ],
        ),
      ),
    ])));
  }

  Uri getDefaultUrl() {
    if (StorageSingleton().isFxHashFlow) {
      StorageSingleton().isFxHashFlow = false;
      return Uri.parse(StorageSingleton().eventUri);
    } else {
      return Uri.parse(
        'https://www.naanwallet.com/dapp.html',
      );
    }
  }
}
