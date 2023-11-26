// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlistMovie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishlistMovieAdapter extends TypeAdapter<WishlistMovie> {
  @override
  final int typeId = 0;

  @override
  WishlistMovie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistMovie(
      title: fields[0] as String?,
      overview: fields[1] as String?,
      posterPath: fields[2] as String?,
      backdropPath: fields[3] as String?,
      voteAverage: fields[4] as String?,
      price: fields[5] as double?,
      imagePath: fields[7] as String?,
      wishlist: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistMovie obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.overview)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.backdropPath)
      ..writeByte(4)
      ..write(obj.voteAverage)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.wishlist)
      ..writeByte(7)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistMovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
