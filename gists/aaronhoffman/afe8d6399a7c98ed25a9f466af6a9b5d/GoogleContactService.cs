public class GoogleContactService
{
  public void CreateContact()
  {
    var cr = this.CreateContactsRequest();
    var groups = cr.GetGroups().Entries.ToList();
    var myContactsSystemGroup = groups.FirstOrDefault(x => x.SystemGroup == "Contacts");
    
    var newContact = new Contact();
    
    // ...
    
    // attempt to add to `My Contacts` system group
    if (myContactsSystemGroup != null && !String.IsNullOrWhiteSpace(myContactsSystemGroup.Id))
    {
        newContact.GroupMembership.Add(new GroupMembership() { HRef = myContactsSystemGroup.Id });
    }
    
    var createUri = this.CreateCreateContactUri();
    var createdEntry = cr.Insert(createUri, newContact);
  }
  
  private ContactsRequest CreateContactsRequest()
  {
    // todo: outside the scope of this gist
  }
  
  private Uri CreateCreateContactUri()
  {
    // todo: outside the scope of this gist
  }
}