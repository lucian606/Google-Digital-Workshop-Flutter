import 'package:movies_modularised/actions/index.dart';
import 'package:movies_modularised/models/index.dart';
import 'package:redux/redux.dart';

Reducer<AppState> reducer = combineReducers(<Reducer<AppState>>[
  TypedReducer<AppState, GetMoviesStart>(_getMoviesStart),
  TypedReducer<AppState, GetMoviesSuccessful>(_getMoviesSuccessful),
]);

AppState _getMoviesStart(AppState state, GetMoviesStart action) {
  return state.rebuild((AppStateBuilder b) => b.isLoading = true);
}

AppState _getMoviesSuccessful(AppState state, GetMoviesSuccessful action) {
  return state.rebuild((AppStateBuilder b) {
    b
      ..movies.addAll(action.movies)
      ..isLoading = false
      ..page = state.page + 1;
  });
}

// AppState reducer(AppState state, dynamic action) {
//   final AppStateBuilder builder = state.toBuilder();
//
//   if (action is GetMoviesStart) {
//     builder.isLoading = true;
//   } else if (action is GetMoviesSuccessful) {
//     builder
//       ..movies.addAll(action.movies)
//       ..isLoading = false
//       ..page = builder.page + 1;
//   } else if (action is GetMoviesError) {
//     builder.isLoading = false;
//   } else if (action is SetQuality) {
//     builder
//       ..quality = action.quality
//       ..movies.clear();
//   } else if (action is SetGenres) {
//     builder
//       ..genres = ListBuilder<String>(action.genres)
//       ..movies.clear();
//   } else if (action is SetOrderBy) {
//     builder
//       ..orderBy = action.orderBy
//       ..movies.clear();
//   }
//
//   return builder.build();
// }
