import 'dart:convert';

main(List<String> args) {
  var json = """{"prim":"Pair","args":[{"prim":"Pair","args":[{"int":"4351"},{"int":"4352"}]},{"prim":"Pair","args":[{"prim":"Pair","args":[{"prim":"Pair","args":[{"prim":"Pair","args":[{"prim":"Pair","args":[{"string":"KT1DLRZD5XTQYydXzGuPhXUx8TdZR2WEmMGS"},{"prim":"Some","args":[{"string":"tz1acZQd7TdfoiUnD2czHnTHB2TaJQP6gdqo"}]}]},{"prim":"Some","args":[{"string":"tz1aRoaRhSpRYvFdyvgWLL6TGyRoGF51wDjM"}]},{"string":"2021-08-06T09:28:34Z"}]},{"prim":"Pair","args":[{"string":"2021-06-03T14:58:58Z"},{"int":"4353"}]},{"string":"2021-09-01T14:58:58Z"},{"int":"26723965"}]},{"prim":"Pair","args":[{"prim":"Pair","args":[{"int":"541497"},{"int":"100532594135802469"}]},{"int":"728296636752"},{"int":"38685292675"}]},{"prim":"Pair","args":[{"string":"KT1A5P4ejnLix13jtadsfV9GCnXLMNnab8UT"},{"int":"0"}]},{"int":"2838533918621815"},{"int":"260580483"}]},{"prim":"Pair","args":[{"prim":"Pair","args":[{"int":"44733428450"},{"int":"1189177749"}]},{"int":"4354"},{"int":"0"}]},{"prim":"Pair","args":[{"int":"4355"},{"int":"4356"}]},{"int":"4357"}]},{"int":"4358"}]}""";
  // print(jsonDecode(json));
  // getParameters(jsonDecode(json));
}

getParameters(Map<String,dynamic> data){
  // var keys = data.keys.toList();
  var key;
  while((key = isThereValueTypeListinMap(data)) != null){
    // print(key);
  }
}

isThereValueTypeListinMap(Map<String,dynamic> data){
  data.forEach((key, value) {
    if(value is List)
    return key;
  });
  return null;
}