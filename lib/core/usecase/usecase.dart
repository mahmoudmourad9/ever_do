import 'package:dartz/dartz.dart';
import '../error/failures.dart';

// Parameters represent the input for the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
