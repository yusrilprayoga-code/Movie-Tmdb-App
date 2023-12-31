class WorldTimeApi {
  final String? abbreviation;
  final String? clientIp;
  final String? datetime;
  final int? dayOfWeek;
  final int? dayOfYear;
  final bool? dst;
  final dynamic dstFrom;
  final int? dstOffset;
  final dynamic dstUntil;
  final int? rawOffset;
  final String? timezone;
  final int? unixtime;
  final String? utcDatetime;
  final String? utcOffset;
  final int? weekNumber;

  WorldTimeApi({
    this.abbreviation,
    this.clientIp,
    this.datetime,
    this.dayOfWeek,
    this.dayOfYear,
    this.dst,
    this.dstFrom,
    this.dstOffset,
    this.dstUntil,
    this.rawOffset,
    this.timezone,
    this.unixtime,
    this.utcDatetime,
    this.utcOffset,
    this.weekNumber,
  });

  WorldTimeApi.fromJson(Map<String, dynamic> json)
      : abbreviation = json['abbreviation'] as String?,
        clientIp = json['client_ip'] as String?,
        datetime = json['datetime'] as String?,
        dayOfWeek = json['day_of_week'] as int?,
        dayOfYear = json['day_of_year'] as int?,
        dst = json['dst'] as bool?,
        dstFrom = json['dst_from'],
        dstOffset = json['dst_offset'] as int?,
        dstUntil = json['dst_until'],
        rawOffset = json['raw_offset'] as int?,
        timezone = json['timezone'] as String?,
        unixtime = json['unixtime'] as int?,
        utcDatetime = json['utc_datetime'] as String?,
        utcOffset = json['utc_offset'] as String?,
        weekNumber = json['week_number'] as int?;

  Map<String, dynamic> toJson() => {
        'abbreviation': abbreviation,
        'client_ip': clientIp,
        'datetime': datetime,
        'day_of_week': dayOfWeek,
        'day_of_year': dayOfYear,
        'dst': dst,
        'dst_from': dstFrom,
        'dst_offset': dstOffset,
        'dst_until': dstUntil,
        'raw_offset': rawOffset,
        'timezone': timezone,
        'unixtime': unixtime,
        'utc_datetime': utcDatetime,
        'utc_offset': utcOffset,
        'week_number': weekNumber
      };
}
