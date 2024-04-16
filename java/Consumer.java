import java.util.concurrent.atomic.AtomicInteger;
public class Consumer implements Runnable {

    private static AtomicInteger to_consumed;
    private final Manager manager;
    private final int id;
    public static void Consumed(int to_consumed){
        Consumer.to_consumed = new AtomicInteger(to_consumed);
    }
    public Consumer(Manager manager, int id){
        this.manager = manager;
        this.id = id;
        new Thread(this).start();;
    }

    @Override
    public void run(){
        while(to_consumed.getAndDecrement() > 0)
        try {
            manager.emptyStorage.acquire();
            manager.accessStorage.acquire();
            Storage item = manager.storageitems.removeFirst();
            System.out.println("Consumer " + this.id + " took " + item.getId());
            manager.accessStorage.release();
            manager.fullStorage.release();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}