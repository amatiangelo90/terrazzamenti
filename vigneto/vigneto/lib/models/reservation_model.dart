
class ReservationModel {

  final String docId;
  final String id;
  final String name;
  final String customerNumber;
  final String date;
  final String reservationDate;
  final String hour;
  final String covers;
  final bool confirmed;

  ReservationModel(
      this.docId,
      this.id,
      this.name,
      this.customerNumber,
      this.date,
      this.reservationDate,
      this.hour,
      this.covers,
      this.confirmed);

  toJson(){
    return {
      'docId' : docId,
      'id' : id,
      'name' : name,
      'customerNumber' : customerNumber,
      'date': date,
      'date': reservationDate,
      'hour': hour,
      'covers' : covers,
      'confirmed' : confirmed,
    };
  }

  factory ReservationModel.fromMap(
      Map snapshot,
      String docId
      ){
    return ReservationModel(
      docId,
      snapshot['id'] as String,
      snapshot['name'] as String,
      snapshot['customerNumber'] as String,
      snapshot['date'] as String,
      snapshot['reservationDate'] as String,
      snapshot['hour'] as String,
      snapshot['covers'] as String,
      snapshot['confirmed'] as bool,
    );
  }
}