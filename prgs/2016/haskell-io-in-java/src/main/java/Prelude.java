import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.function.Function;

public class Prelude {
  public static final Function<String, IO<Void>> putStrLn =
    (string) -> new IO<>(() -> {
      System.out.println(string);
      return null;
    });

  public static final IO<String> getLine =
    new IO<>(() -> {
      BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
      return reader.readLine();
    });
}
