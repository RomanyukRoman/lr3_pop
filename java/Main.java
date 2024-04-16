public class Main{
    public static void main(String[] args){
        int num_producer = 4;
        int num_consumer = 5;
        int storageSize = 3;
        int totalnum = 10;
        Manager manager = new Manager(storageSize);
        Producer.Produce(totalnum);
        Consumer.Consumed(totalnum);
        for(int i = 0; i < num_producer; i++){
            new Producer(manager, i + 1);
        }
        for(int i = 0; i < num_consumer; i++){
            new Consumer(manager, i + 1);
        }
    }
}