package info.igreque.the.haskellioinjava;

/**
 * Haskellの処理系が提供してくれる部分のうち、
 * ユーザーが定義したmodule（今回の場合IOSample）の
 * main関数を実際に実行するプログラム。
 */


public class RunIOSample {
  public static void main(String args[]) throws Exception {
    IO.runMain(IOSample.main);
  }
}
