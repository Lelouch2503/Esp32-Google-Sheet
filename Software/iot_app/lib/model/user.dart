class UserFields {
 static const String Light = "Light";
 static const String Humidity = "Humidity";
 static const String Pump = "Pump";
 static const String timeLight = "timeLight";
 static const String timeHumidity = "timeHumidity";

 static List<String> getFields() => [Light, Humidity, Pump];
}

class User{
 final int? Light;
 final int Humidity;
 final int Pump;
 final String timeLight;
 final String timeHumidity;

 const User({required this.Light, required this.Humidity, required this.Pump, required this.timeLight, required this.timeHumidity});


 Map<String, dynamic> toJson() => {
  UserFields.Light: Light,
  UserFields.Humidity: Humidity,
  UserFields.Pump: Pump,
  UserFields.timeLight: timeLight,
  UserFields.timeHumidity: timeHumidity,
 };
}
