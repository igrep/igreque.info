package info.igreque.the.haskellioinjava;

import java.io.BufferedReader;
import java.io.InputStreamReader;

/**
 * 入門書の最初の方に載っていそうな、
 * 「ユーザーの名前を（標準入力から）聞いて、名前を誉めつつ画面に表示する」
 * だけのプログラム。
 *
 * このリポジトリーでは、
 * Haskellの（純粋な）関数をJavaの`Function`で、
 * `IO`を先ほど作ったJavaの`IO`に例えて、
 * このプログラムを書き換える。
 */

public class IOSampleInOrdinaryJava {
  public static void main(String args[]) throws Exception {
    // 挨拶のあと、名前を尋ねて、
    System.out.println("Nice to meet you!");
    System.out.println("May I have your name? ");
    
    // 標準入力から名前を取得して、
    BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
    String name = reader.readLine();

    // 名前を誉める
    System.out.println("Your name is " + name + "?");
    System.out.println("Nice name!");
  }
}
