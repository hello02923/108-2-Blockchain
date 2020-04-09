 pragma solidity ^0.6.0;
 contract laibank {
     mapping (string => address) students; //學號映射到地址
     mapping (address => uint) balances; //地址映射到存款金額


     address payable owner;//銀行的擁有者，會在constructor做設定
     address studentaddress;
     
     modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

     //建立一個銀行裡面有多少錢
     constructor() public payable{ 
         owner= msg.sender;
     }
     
     //當觸發fallback時，檢查觸發者是否為owner，是則自殺合約，把合約剩餘的錢轉給owner
      fallback () external {
      require(msg.sender == owner, "Permission denied");
      selfdestruct(owner);
      }

     //可以讓使用者call這個函數把錢存進合約地址，並且在balances中紀錄使用者的帳戶金額
     function deposit(address studentaddress, uint money) public payable{
         money = msg.value;
         require(money > 0,"error message!");
         balances[studentaddress] += money;
    
     }
     //可以讓使用者從合約提錢，這邊需要去確認合約裡的餘額 >= 想提的金額
     function withdraw(address studentaddress, uint get) public returns(uint256){
         require(balances[studentaddress] >= get && get > 0,"error message! you don't have enough money! ");
         balances[studentaddress] -= get;
         return balances[msg.sender];
        
     }
     //可以讓使用者從合約轉帳給某個地址，這邊需要去確認合約裡的餘額 >= 想轉的金額
     //實現的是銀行內部轉帳，也就是說如果轉帳成功balances的目標地址會增加轉帳金額
     
     function transfer(uint amount, address payable goaladdress,address studentaddress) external payable returns(uint256){
         require(balances[studentaddress] >= amount && amount > 0,"error message!");
        //  goaladdress.transfer(amount);
         balances[studentaddress]-=amount;
         balances[goaladdress]+=amount;
         return balances[studentaddress];
        }
    
    
    
    //從balances回傳使用者的銀行帳戶餘額
     function getBalance() external view returns(uint){
         return balances[msg.sender];
       
     }
     
     //回傳銀行合約的所有餘額，設定為只有owner才能呼叫成功
     function getBankBalance() public view onlyOwner returns(uint){
         //require(msg.sender==owner,"error message");
         return address(this).balance;
        
     }
     
     //透過students把學號映射到使用者的地址
     function enroll(string memory studentid) public {
         students[studentid]=msg.sender;
     }
    
 }
