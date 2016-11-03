package info.igreque.the.haskellioinjava;

public class IOSample {
  public static final IO<Void> main =
    Prelude.putStrLn.apply("Nice to meet you!")
      .plus(Prelude.putStrLn.apply("May I have your name? "))
      .plus(
        Prelude.getLine
          .then((name) ->
            Prelude.putStrLn.apply("Your name is " + name + "?")
              .plus(Prelude.putStrLn.apply("Nice name!"))
          )
      );
}
