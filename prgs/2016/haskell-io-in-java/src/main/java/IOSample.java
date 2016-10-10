public class IOSample {
  public static final IO<Void> main =
    Prelude.putStrLn.apply("Nice to meet you!")
      .chain(Prelude.putStrLn.apply("May I have your name? "))
      .chain(
        Prelude.getLine
          .then((name) ->
            Prelude.putStrLn.apply("Your name is " + name + "?")
              .chain(Prelude.putStrLn.apply("Nice name!"))
          )
      );

  public static void main(String args[]) throws Exception {
    IO.runMain(main);
  }
}
