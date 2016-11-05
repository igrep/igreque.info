package info.igreque.the.haskellioinjava;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class IOSampleInOrdinaryJava {
  public static void main(String args[]) throws Exception {
    System.out.println("Nice to meet you!");
    System.out.println("May I have your name? ");
    BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
    String name = reader.readLine();
    System.out.println("Your name is " + name + "?");
    System.out.println("Nice name!");
  }
}


