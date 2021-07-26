class Configuration {

  final String id;
  final String key;
  final String conf;


  Configuration(this.id, this.key, this.conf);

  toJson(){

    return {
      'id' : id,
      'key' : key,
      'conf': conf
    };
  }


  @override
  String toString() {
    return this.key + ' - ' + this.conf;
  }

  factory Configuration.fromMap(
      Map snapshot,
      String id){

    return Configuration(
      id,
      snapshot['key'] as String,
      snapshot['conf'] as String
    );
  }


}