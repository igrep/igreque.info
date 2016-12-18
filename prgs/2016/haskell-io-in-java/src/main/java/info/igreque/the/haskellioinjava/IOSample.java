package info.igreque.the.haskellioinjava;

import static info.igreque.the.haskellioinjava.Prelude.putStrLn;
import static info.igreque.the.haskellioinjava.Prelude.getLine;

/**
 * {@code IO} を使用した、単純なサンプルプログラム。
 * Haskellでプログラムを書く際、プログラマーは下記のように、
 * {@code Prelude} などで定義した各種IO型の値（putStrLn, getLine）を
 * 「組み合わせる」ことでmainを作る。
 */

public class IOSample {
  /**
   * プログラマーが作る、実際にHaskellの処理系が実行するプログラムの中身。
   * CやJavaなどと似たように、mainという名前で宣言された関数
   * (Haskellの場合はIOオブジェクト)が実行される。
   *
   * HaskellにはJavaで言うところのクラスやオブジェクトの区別がないため、
   * ローカル変数に格納されるものを除き、
   * 全ての値はstatic finalな定数に格納される、とここでは例えた。
   */
  public static final IO<Void> main =
    putStrLn.apply("Nice to meet you!")
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
