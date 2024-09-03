class DeviceListResponse {
  final List<dynamic>? errors;
  final List<Data>? data;

  DeviceListResponse({
    this.errors,
    this.data,
  });

  DeviceListResponse.fromJson(Map<String, dynamic> json)
      : errors = json['errors'] as List?,
        data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'errors' : errors,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class Data {
  final String? id;
  final ProductData? productData;
  final Metadata? metadata;
  // final Identify? identify;
  final List<Services>? services;
  final String? type;

  Data({
    this.id,
    this.productData,
    this.metadata,
    // this.identify,
    this.services,
    this.type,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        productData = (json['product_data'] as Map<String,dynamic>?) != null ? ProductData.fromJson(json['product_data'] as Map<String,dynamic>) : null,
        metadata = (json['metadata'] as Map<String,dynamic>?) != null ? Metadata.fromJson(json['metadata'] as Map<String,dynamic>) : null,
        // identify = (json['identify'] as Map<String,dynamic>?) != null ? Identify.fromJson(json['identify'] as Map<String,dynamic>) : null,
        services = (json['services'] as List?)?.map((dynamic e) => Services.fromJson(e as Map<String,dynamic>)).toList(),
        type = json['type'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'product_data' : productData?.toJson(),
    'metadata' : metadata?.toJson(),
    // 'identify' : identify?.toJson(),
    'services' : services?.map((e) => e.toJson()).toList(),
    'type' : type
  };
}

class ProductData {
  final String? modelId;
  final String? manufacturerName;
  final String? productName;
  final String? productArchetype;
  final bool? certified;
  final String? softwareVersion;

  ProductData({
    this.modelId,
    this.manufacturerName,
    this.productName,
    this.productArchetype,
    this.certified,
    this.softwareVersion,
  });

  ProductData.fromJson(Map<String, dynamic> json)
      : modelId = json['model_id'] as String?,
        manufacturerName = json['manufacturer_name'] as String?,
        productName = json['product_name'] as String?,
        productArchetype = json['product_archetype'] as String?,
        certified = json['certified'] as bool?,
        softwareVersion = json['software_version'] as String?;

  Map<String, dynamic> toJson() => {
    'model_id' : modelId,
    'manufacturer_name' : manufacturerName,
    'product_name' : productName,
    'product_archetype' : productArchetype,
    'certified' : certified,
    'software_version' : softwareVersion
  };
}

class Metadata {
  final String? name;
  final String? archetype;

  Metadata({
    this.name,
    this.archetype,
  });

  Metadata.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        archetype = json['archetype'] as String?;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'archetype' : archetype
  };
}



class Services {
final String? rid;
final String? rtype;

Services({
this.rid,
this.rtype,
});

Services.fromJson(Map<String, dynamic> json)
    : rid = json['rid'] as String?,
rtype = json['rtype'] as String?;

Map<String, dynamic> toJson() => {
'rid' : rid,
'rtype' : rtype
};
}