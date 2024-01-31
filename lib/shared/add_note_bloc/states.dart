abstract class AddNotesStates {}

class InitState extends AddNotesStates {}

class SuccessPutImages extends AddNotesStates {}


class RemoveImages extends AddNotesStates {}
class RemoveSearch extends AddNotesStates {}
class ChangeFavourite extends AddNotesStates {}
class SelectCategory extends AddNotesStates {}
class FormatNoteImages extends AddNotesStates {}

class SuccessUpdateNoteID extends AddNotesStates {}
class ErrorUpdateNoteID extends AddNotesStates {}

class LeadingUpdateFavoriteField extends AddNotesStates {}
class SuccessUpdateFavoriteField extends AddNotesStates {}
class ErrorUpdateFavoriteField extends AddNotesStates {}



class LeadingUpdateCategoryField extends AddNotesStates {}
class SuccessUpdateCategoryField extends AddNotesStates {}
class ErrorUpdateCategoryField extends AddNotesStates {}


class LeadingCreatePost extends AddNotesStates {}
class SuccessCreatePost extends AddNotesStates {}
class ErrorCreatePost extends AddNotesStates {}


class LeadingSearchNote extends AddNotesStates {}
class SuccessSearchNote extends AddNotesStates {}
class ErrorSearchNote extends AddNotesStates {}


class LeadingUploadImages extends AddNotesStates {}
class SuccessUploadImages extends AddNotesStates {}
class ErrorUploadImages extends AddNotesStates {}

class LeadingUpdateNote extends AddNotesStates {}
class SuccessUpdateNote extends AddNotesStates {}
class ErrorUpdateNote extends AddNotesStates {}


class LeadingGetNotes extends AddNotesStates {}
class SuccessGetNotes extends AddNotesStates {}
class ErrorGetNotes extends AddNotesStates {}


class LeadingDeleteNote extends AddNotesStates {}
class SuccessDeleteNote extends AddNotesStates {}
class ErrorDeleteNote extends AddNotesStates {}


class LeadingInsertImagesInNote extends AddNotesStates {}
class SuccessInsertImagesInNote extends AddNotesStates {}
class ErrorInsertImagesInNote extends AddNotesStates {}


class LeadingCalculateFolderSize extends AddNotesStates {}
class SuccessCalculateFolderSize extends AddNotesStates {}
class ErrorCalculateFolderSize extends AddNotesStates {}