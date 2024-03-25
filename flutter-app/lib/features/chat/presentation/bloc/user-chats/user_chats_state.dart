part of 'user_chats_bloc.dart';

sealed class UserChatsState extends Equatable {
  const UserChatsState();

  @override
  List<Object> get props => [];
}

final class UserChatsInitial extends UserChatsState {}

final class UsersChatsFetching extends UserChatsState {
  final List<ChatModel> chats;
  final int totalUnreadMessages;
  const UsersChatsFetching(this.chats, this.totalUnreadMessages);
  @override
  List<Object> get props => [chats, totalUnreadMessages];
}

final class UsersChatsFetchFailed extends UserChatsState {
  final String message;

  const UsersChatsFetchFailed(
    this.message,
  );

  @override
  List<Object> get props => [
        message,
      ];
}

final class UsersChatsFetched extends UserChatsState {
  final int totalUnreadMessages;
  final List<ChatModel> chats;
  const UsersChatsFetched(this.chats, this.totalUnreadMessages);

  @override
  List<Object> get props => [chats, totalUnreadMessages];
}
