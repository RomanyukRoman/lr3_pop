import java.util.concurrent.atomic.AtomicInteger;
import java.util.Random;

public class Producer implements Runnable {

    private static AtomicInteger to_produce;
    private final Manager manager;
    private final int id;
    public static void Produce(int to_produce){
        Producer.to_produce = new AtomicInteger(to_produce);
    }

    public Producer(Manager manager, int id){
        this.manager = manager;
        this.id = id;
        new Thread(this).start();
    }
    @Override
    public void run(){
        while (to_produce.getAndDecrement() > 0) {
            try{
                manager.fullStorage.acquire();
                manager.accessStorage.acquire();
                Random random = new Random();
                Storage item = new Storage(random.nextInt(0, 1000)); 
                manager.storageitems.add(item);
                System.out.println("Producer " + this.id + " added item " + item.getId());
                manager.accessStorage.release();
                manager.emptyStorage.release();
                } catch (InterruptedException e) {
                    e.printStackTrace();;
            }
         }
    }
}