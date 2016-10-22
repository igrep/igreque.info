import java.util.concurrent.Callable;
import java.util.function.Function;

public class IO<T1> {
  private final Callable<T1> internalAction;

  IO(Callable<T1> internalAction){
    this.internalAction = internalAction;
  }

  public <T2> IO<T2> chain(IO<T2> nextIo) {
    return new IO<>(() -> {
      internalAction.call();
      return nextIo.internalAction.call();
    });
  }

  public <T2> IO<T2> then(Function<T1, IO<T2>> makeNextIo) {
    return new IO<>(() -> {
      T1 result = internalAction.call();
      IO<T2> nextIo = makeNextIo.apply(result);
      return nextIo.internalAction.call();
    });
  }

  // 実際に実行するために便宜上必要。
  static void runMain(IO<Void> mainIo) throws Exception {
    mainIo.internalAction.call();
  }
}
