#Array Cheatsheet

#region Array Creation
$counter = @()                                      #empty array
$Fruit_Array = @('Apple','Banana','Peach')          #@() is known as the array subexpression operator which just returns the results of whats inside the () as an array            
$Servers = "VM1","VM2","VM3"                        #Can construct an array with a comma seperated list too
[string[]]$Dogs = ('Labrador','Boxer')              #In this example we casted the string[] which constructs an array of strings from the input
[string]$Dogs_copy = ('Labrador','Boxer')           #As an exercise look at the type of $Dogs and $Dogs_copy, notice the subtle difference in [] and figure out why that is


#powershell automatically creates an array object for you when you return more than one element, so you should leave array creation to powershell itself when possible
#in fact letting powershell handle most things is probably advised when you're new e.g. error handling/object creation/etc
$bucket = 1..100 | ForEach-Object {
    $_
}
($bucket.GetType()).BaseType.Name                   #returns 'Array' as the BaseType
#endregion

#region Accessing specific elemets of arrays

$servers                                            #returns entire array
$Servers[0]                                         #returns first element
$servers[-1]                                        #returns last element
$servers[0..1]                                      #returns a range of elements, this case the first two elements
$servers[-2..-1]                                    #returns last two elements in ascending order
$servers[-1..-2]                                    #returns last two elements in descending order
$servers_array = 0..10                              #initlaize the array
$servers_array[1,3,5,7,9]                           #can use commas to list specific elements, returns 1,3,5,7,9
$servers_array[0,3+6..9]                            #can use combination of specific elements and ranges with '+'. returns 0 3 6 7 8 9

#can also iterate through the array with various loops to access elements
ForEach ($server in $servers){
    $server
}

#the traditional for loop construct from other languages...not really used much in powershell but can be i guess
#print the even numbers btween 0-100
for ($i=0;$i -le 100;$i++) {
    if($i%2 -eq 0) {
        "{0}" -f $i
    }
}
#endregion

#region Array methods
$servers.ForEach({$_ + "-Prod"})                        #common methods for working with objects inside arrays are .Where() and .Foreach()
$Dogs.Where{ $_ -like "*Lab*" }                         #these are known as intrinsic members, created by powershell engine upon object creation

$server | foreach-object {$_ + "-Prod"}                 #achieves the same thing but by invoking the pipeline there is a *slight* performance hit
$Dogs | Where-object {$_ -like "*Lab*"}                 #so I tend to try and use the intrinsic member approach for optimal performance where possible instead of pipeline

$Fruit_Array | Get-Member -MemberType Method            #find methods for the array object itself
Get-Member -InputObject $Fruit_Array -MemberType Method #gets the methods of the members inside the array. Note this is different than the command above..
,$Fruit_Array | Get-Member -MemberType Method           #functionally equivalent to the command above. appending a comma achieves the same goal

#Key takeaway...use Get-Member to find member properties of any object
#endregion
