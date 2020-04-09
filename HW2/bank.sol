 pragma solidity ^0.6.0;
 contract laibank {
     mapping (string => address payable) students; //學號映射到地址
     mapping (address => uint) balances; //地址映射到存款金額
     mapping(address => bool) check;//確定有這個帳戶

     address payable owner;//銀行的擁有者，會在constructor做設定
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
     function deposit() public payable{
         require(check[msg.sender],"error message!");
         require(msg.value > 0,"error message!");
         balances[msg.sender] += msg.value;
    
     }
     //可以讓使用者從合約提錢，這邊需要去確認合約裡的餘額 >= 想提的金額
     function withdraw(uint get) public payable returns(uint256){
         require(check[msg.sender]=true,"Permission denied");
         require(balances[msg.sender] >= get && get > 0,"error message! you don't have enough money! ");
         msg.sender.transfer(get);
         balances[msg.sender] -= get;
         return balances[msg.sender];
        
     }
     //可以讓使用者從合約轉帳給某個地址，這邊需要去確認合約裡的餘額 >= 想轉的金額
     //實現的是銀行內部轉帳，也就是說如果轉帳成功balances的目標地址會增加轉帳金額
     
     function transfer(uint amount, address payable goaladdress) external payable returns(uint256){
         require(balances[msg.sender] >= amount && amount > 0,"error message!");
         goaladdress.transfer(amount);
        //  balances[studentaddress]-=amount;
        //  balances[goaladdress]+=amount;
         return balances[msg.sender];
        }
    
    
    //從balances回傳使用者的銀行帳戶餘額
     function getBalance() external view returns(uint){
         require(check[msg.sender],"error message!");
         return balances[msg.sender];
     }
     
     //回傳銀行合約的所有餘額，設定為只有owner才能呼叫成功
     function getBankBalance() public view onlyOwner returns(uint){
         return address(this).balance;
        
     }
     
     //透過students把學號映射到使用者的地址
     function enroll(string calldata studentid) external {
         check[msg.sender] = true;
         students[studentid] = msg.sender;
         balances[msg.sender] = 0;
     }
    
 }
