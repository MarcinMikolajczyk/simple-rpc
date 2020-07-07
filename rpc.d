import std.socket, std.stdio, core.thread, std.file, std.datetime, std.conv;
import std.array, std.algorithm, std.string, std.json;

int add(int a, int b){
  return a + b;
}

int sub(int a, int b){
  return a - b;
}

struct Function {
  string argc;
  string argv;
};

void main(string[] args){

  Function[string] rpc_functions = [
    "add" : Function("2", "int int"),
    "sub" : Function("2", "int int")
  ];


  auto listener = new Socket(AddressFamily.INET, SocketType.STREAM);
  listener.bind(new InternetAddress("0.0.0.0", 8080));
  listener.listen(10);

  bool isRunning = true;

  while(isRunning){
    string request;
    char[1024] buffer;
    auto client = listener.accept();
    writeln(Clock.currTime(UTC()).toString() ~ " [ INFO ] Connected client : " ~ client.hostName());

    long length = client.receive(buffer);

    if(length == 0){
      client.shutdown(SocketShutdown.BOTH);
      continue;
    }

    request ~= buffer;

    JSONValue j = parseJSON(request);

    client.send(buffer);
    client.shutdown(SocketShutdown.BOTH);
  }

}
