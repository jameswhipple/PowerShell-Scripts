#Learning all about Arrays in PowerShell

#-----Different ways to create arrays-----#
#note most of these are STRONGLY TYPED ARRAYS as we've casted the type 
[string[]]$Fruit_Array = @('Apple','Banana','Peach')
[string[]]$Servers = "VM1","VM2","VM3"
[int[]]$User_Count = 1..5
$Dog_Breeds = [array]('Poodle','Bloodhound')
[array]$Dog_Breeds2 = ('Labrador','Boxer')
$counter = @() #empty array

#powershell automatically creates an array object for you when you return more than one element, so you should leave array creation to powershell itself when possible
[int[]]$bucket = 1..100 | ForEach-Object {
    $_
}
($bucket.GetType()).BaseType.Name #returns 'Array' as the BaseType
#-----ENDOF creation section-----#


#----Accessing elements of an array----#
$servers #returns entire array
$Servers[0] #returns first element
$servers[-1] #returns last element
$servers[0..1] #returns a range of elements, this case the first two elements
$servers[-2..-1] #returns last two elements in ascending order
$servers[-1..-2] #returns last two elements in descending order
$servers_array = 0..10 #initlaize the array
$servers_array[1,3,5,7,9] #can use commas to list specific elements, returns 1,3,5,7,9
$servers_array[0,3+6..9] #can use combination of specific elements and ranges with '+'. returns 0 3 6 7 8 9

#can also iterate through the array with various loops to access elements
ForEach ($server in $servers){
    $server
}
#----ENDOF accessing array elements----#


#----Array methods----#
#common methods for working with objects inside arrays are .Where() and .Foreach()
#these are known as intrinsic members, created by powershell engine upon object creation
#to see these hidden members/properties use Get-Member -Force
$servers.ForEach({$_ + "-Prod"}) #adds -Prod to end of each string
$Dog_Breeds2.Where{ $_ -like "*Lab*" } #notice you can omit the paranthesis

$Fruit_Array | Get-Member -MemberType Method #find methods for the array
Get-Member -InputObject $Fruit_Array -MemberType Method #gets the methods of the members inside the array. Note this is different than the command above..
,$Fruit_Array | Get-Member -MemberType Method #functionally equivalent to the command above. That is appending a comma achieves the same goal
#just remeber to use Get-Member to find member properties of any object
#----ENDOF Array methods----#


#----Array manipulation---#
#by definition an array is a collection of fixed size, so there's no .Add() method because you're not expected to expand fixed size collections
#to get around this, you can use += to add new elements, but it's an expensive operation since the entire old array is copied into a new one + the new element is added
$Fruit_Array.IsFixedSize #returns TRUE
$Fruit_Array += "Pineapple" #bad bad bad bad bad in production code

#Instead use Lists or ArrayLists if anticipating your Array to grow
$Fruit_ArrayList = [System.Collections.ArrayList]('Apple','Banana','Peach')
$Fruit_ArrayList.IsFixedSize #returns FALSE
(,$Fruit_ArrayList | Get-Member -MemberType Method).Where{$_.Name -like "Add*"} #get the methods like Add*
$Fruit_ArrayList.Add('Pineapple') > $null #redirect output to $null to suppress index of newly added element being returned
$Fruit_ArrayList.Add('Pineapple')  #notice how this is different from above
#----ENDOF Array Manipulation----#


