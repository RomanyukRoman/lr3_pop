with Ada.Text_IO, GNAT.Semaphores;
use Ada.Text_IO, GNAT.Semaphores;

with Ada.Containers.Indefinite_Doubly_Linked_Lists;
use Ada.Containers;

procedure Main is
   package String_Lists is new Indefinite_Doubly_Linked_Lists(String);
   use String_Lists;

   Storage_Size : Integer := 3;
   num_Producer : Integer := 1;
   num_Consumer : Integer := 4;
   total_num : Integer := 10;

   Storage : List;
   Access_Storage : Counting_Semaphore(1, Default_Ceiling);
   Full_Storage : Counting_Semaphore(Storage_Size, Default_Ceiling);
   Empty_Storage : Counting_Semaphore(0, Default_Ceiling);

   protected Manager is
      procedure DecrementProdCount;
      function Producer_Complete return Boolean;
      procedure DecrementConsCount;
      function Consumer_Complete return Boolean;
   private
      ItemsLeftToProduce : Integer := total_num;
      ItemsLeftToConsume : Integer := total_num;
   end Manager;

   protected body Manager is

      procedure DecrementProdCount is
      begin
         if ItemsLeftToProduce > 0 then
            ItemsLeftToProduce := ItemsLeftToProduce - 1;
         end if;
      end DecrementProdCount;

      function Producer_Complete return Boolean is
      begin
         return ItemsLeftToProduce = 0;
      end Producer_Complete;

      procedure DecrementConsCount is
      begin
         if ItemsLeftToConsume > 0 then
            ItemsLeftToConsume := ItemsLeftToConsume - 1;
            end if;
      end DecrementConsCount;

      function Consumer_Complete return Boolean is
      begin
         return ItemsLeftToConsume = 0;
      end Consumer_Complete;
   end Manager;

   task type Producer is
      entry Start(num : Integer);
   end Producer;

   task body Producer is
      id : Integer;
      item : Integer;
      i : Integer := 1;
   begin
      accept Start (num : in Integer) do
         Producer.id := num;
      end Start;
      while not Manager.Producer_Complete loop
         Manager.DecrementProdCount;
         Full_Storage.Seize;
         Access_Storage.Seize;
         item := i;
         i := i + 1;
         Storage.Append("item" & Item'Img);
         Put_Line("Producer" & id'Img & " add item" & item'Img);
         Access_Storage.Release;
         Empty_Storage.Release;
      end loop;
   end Producer;

   task type Consumer is
      entry Start(num: Integer);
   end Consumer;

   task body Consumer is
      id : Integer;
   begin
      accept Start(num : Integer) do
        Consumer.id := num;
   end Start;

   while not Manager.Consumer_Complete loop
      Manager.DecrementConsCount;
      Empty_Storage.Seize;
      Access_Storage.Seize;
         declare
            item : String := First_Element(Storage);
         begin
            Put_Line("Consumer" & id'Img & " took " & item);
            Storage.Delete_First;
            Access_Storage.Release;
            Full_Storage.Release;
         end;
      end loop;
   end Consumer;

   producer_array : array(1..num_Producer) of Producer;
   consumer_array : array(1..num_Consumer) of Consumer;

begin
   for i in 1..num_Producer loop
      producer_array(i).Start(i);
   end loop;
   for i in 1..num_Consumer loop
      consumer_array(i).Start(i);
   end loop;
end Main;
