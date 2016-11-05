package info.igreque.the.haskellioinjava;

import static info.igreque.the.haskellioinjava.Prelude.putStrLn;
import static info.igreque.the.haskellioinjava.Prelude.getLine;
public class IOSample {
  public static final IO<Void> main =
    Prelude.putStrLn.apply("Nice to meet you!")
      .plus(
        putStrLn.apply("May I have your name? ")
      )
      .plus(
        getLine
          .then((name) ->
            putStrLn.apply("Your name is " + name + "?")
              .plus(putStrLn.apply("Nice name!"))
          )
      );
}
