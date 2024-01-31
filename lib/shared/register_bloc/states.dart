abstract class RegisterStates{}


class InitialState extends RegisterStates{}


class ChangePasswordIcon extends RegisterStates{}


class SuccessChooseDate extends RegisterStates{}
class ErrorChooseDate extends RegisterStates{}

class SuccessPutImage extends RegisterStates{}
class ErrorPutImage extends RegisterStates{}


class LeadingRegister extends RegisterStates{}
class SuccessRegister extends RegisterStates{}
class ErrorRegister extends RegisterStates{}


class ErrorCreateUser extends RegisterStates{}
class SuccessCreateUser extends RegisterStates{}


class LeadingUploadProfile extends RegisterStates{}
class SuccessUploadProfile extends RegisterStates{}
class ErrorUploadProfile extends RegisterStates{}

class LeadingFetchEmail extends RegisterStates{}
class SuccessFetchEmail extends RegisterStates{}
class ErrorFetchEmail extends RegisterStates{}


class LeadingCreateProfileLists extends RegisterStates {}
class SuccessCreateProfileLists extends RegisterStates {}
class ErrorCreateProfileLists extends RegisterStates {}


class LeadingCheckTheCode extends RegisterStates {}


class SuccessUpdateValueCode extends RegisterStates {}
class ErrorUpdateValueCode extends RegisterStates {}