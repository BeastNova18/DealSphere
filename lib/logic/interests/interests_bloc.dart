import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'interests_event.dart';
import 'interests_state.dart';

class InterestsBloc extends Bloc<InterestsEvent, InterestsState> {
  static const _prefsKey = 'interested_deals';

  InterestsBloc() : super(const InterestsState()) {
    on<InterestsLoaded>(_onLoaded);
    on<InterestToggled>(_onToggled);
    add(InterestsLoaded());
  }

  Future<void> _onLoaded(InterestsLoaded event, Emitter emit) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefsKey) ?? [];
    emit(state.copyWith(interestedDealIds: saved.toSet()));
  }

  Future<void> _onToggled(InterestToggled event, Emitter emit) async {
    final updated = Set<String>.from(state.interestedDealIds);
    if (updated.contains(event.dealId)) {
      updated.remove(event.dealId);
    } else {
      updated.add(event.dealId);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, updated.toList());
    emit(state.copyWith(interestedDealIds: updated));
  }
}
