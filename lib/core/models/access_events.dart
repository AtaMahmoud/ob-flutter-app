import 'package:json_annotation/json_annotation.dart';
import 'package:ocean_builder/core/models/access_request.dart';

part 'access_events.g.dart';

@JsonSerializable()
class AccessEvents {
  List<AccessEvent>? sentInvitations;
  List<AccessEvent>? receivedInvitations;
  List<AccessEvent>? sentRequests;
  List<AccessEvent>? receivedRequests;

  AccessEvents(
      {this.sentInvitations,
      this.receivedInvitations,
      this.sentRequests,
      this.receivedRequests});

  factory AccessEvents.fromJson(Map<String, dynamic> json) =>
      _$AccessEventsFromJson(json);

  Map<String, dynamic> toJson() => _$AccessEventsToJson(this);
}
