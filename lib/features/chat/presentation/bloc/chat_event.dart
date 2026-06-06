import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

// Event fired when user sends message
class SendMessageEvent extends ChatEvent {
  final String message;

  const SendMessageEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
