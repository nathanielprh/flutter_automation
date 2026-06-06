import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/profile_repository.dart';

import 'profile_event.dart';

import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_loadProfile);

    on<UpdateUsernameEvent>(_updateUsername);
  }

  /// Called when profile page opens
  Future<void> _loadProfile(
    LoadProfileEvent event,

    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final profile = await repository.getProfile();

      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  /// Called when user updates username
  Future<void> _updateUsername(
    UpdateUsernameEvent event,

    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final updatedProfile = await repository.updateUsername(event.username);

      emit(ProfileLoaded(updatedProfile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
