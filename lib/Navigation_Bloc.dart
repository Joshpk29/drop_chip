import 'package:bloc/bloc.dart';
import 'Discover.dart';
import 'addRecipe.dart';
import 'settings.dart';

enum NavigationEvents {
  DiscoverPageClicked,
  addRecipePageClicked,
  UtilityClicked
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  final Function onMenuTap;
  final String email;
  final String password;
  final String uid;
  NavigationBloc({this.onMenuTap,this.email,this.password,this.uid});

  @override
  NavigationStates get initialState => DiscoverPage(
    onMenuTap: onMenuTap,
  );

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.DiscoverPageClicked:
        yield DiscoverPage(
          uid: uid,
          onMenuTap: onMenuTap,
        );
        break;
      case NavigationEvents.addRecipePageClicked:
        yield addRecipePage(
          uid: uid,
          onMenuTap: onMenuTap,
        );
       break;
      case NavigationEvents.UtilityClicked:
        yield settings(
          uid: uid,
          email: email,
          password: password,
          onMenuTap: onMenuTap,
        );
        break;
    }
  }
}