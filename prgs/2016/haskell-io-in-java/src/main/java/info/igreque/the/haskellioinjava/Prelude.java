package info.igreque.the.haskellioinjava;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.function.Function;

/**
 * Haskellのコンパイラーが提供してくれる部分のうち、
 * 「Prelude」と呼ばれるHaskellの組み込みmodule（の一部）を再現した。
 * IOSampleと同様に、提供する関数はすべてpublic static finalな定数として提供している。
 */

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
