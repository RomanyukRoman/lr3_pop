import java.util.ArrayList;
import java.util.concurrent.Semaphore;

public class Manager {

    public final Semaphore emptyStorage;
    public final Semaphore fullStorage;
    public final Semaphore accessStorage;

    public ArrayList<Storage> storageitems;

    public Manager(int storageSize){
        accessStorage = new Semaphore(1);
        emptyStorage = new Semaphore(0);
        fullStorage = new Semaphore(storageSize);
        this.storageitems = new ArrayList<Storage>(storageSize);

    }
}