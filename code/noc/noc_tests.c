#include "printf.h"
#include "noc.h"


void roundtrip_test()
{

    uint32_t hart_id = get_hart_id();
    uint32_t data = 1;
    uint32_t res;
    if(hart_id == 0){
        write_data(1,&data, 1);
        send_data(1);
    }
    else if(hart_id == 1)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
    else if(hart_id == 2)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
    else if(hart_id == 3)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
      else if(hart_id == 4)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
      else if(hart_id == 5)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
      else if(hart_id == 6)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
    else if(hart_id == 7)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
    else if(hart_id == 8)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
      else if(hart_id == 9)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
      else if(hart_id == 10)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
      else if(hart_id == 11)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
    else if(hart_id == 12)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
    else if(hart_id == 13)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
      else if(hart_id == 14)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(hart_id + 1,&data,1);
        send_data(hart_id + 1);
    }
      else if(hart_id == 15)
    {
        poll_on_receive(hart_id - 1);
        read_data(hart_id -1,&res,1);
        printf("received from [%d] %d\n",hart_id-1,res);
        data = data + res;
        write_data(0,&data,1);
        send_data(0);
   
    }

    if(hart_id == 0){
        poll_on_receive(15);
        read_data(15,&res,1);
        printf("received from [%d] %d\n",15,res);
    }
    
    wfi();
    

}

void array_test()
{
    uint32_t array1 [NOC_NODES];
    uint32_t array2 [NOC_NODES];
    uint32_t result [NOC_NODES];
    uint32_t *acc_result;
    uint32_t sum ;
    for(int i = 0; i < NOC_NODES; i++){
        array1[i] = i;
        array2[i] = i+1;
    }
    
    for(int i = 1; i < NOC_NODES; i++){
        if(get_hart_id() == 0){
            uint32_t to_send[2] = {array1[i], array2[i]};
            write_data(i,to_send,2);
            send_data(i);
        }

    }
 
   if(get_hart_id()!=0){
            poll_on_receive(0);
            
            read_data(0, result,2);
            sum = result[0] + result[1];
            write_data(0, &sum, 1);
            send_data(0);
    }
    else if(get_hart_id() == 0)
    {
        for(int i = 1; i < NOC_NODES; i++){
            poll_on_receive(i);
            uint32_t res = read_data_single(i,0);
            printf("Got result from [%d] : %d\n", i,res);
        }
    
    }
    wfi();
}


int main(){
    
   
    
   // array_test();
    roundtrip_test();

}