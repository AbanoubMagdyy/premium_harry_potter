abstract class SignInStates {}


class InitialSignInState extends SignInStates {}


class ChangeSignInPasswordIcon extends SignInStates {}



class LeadingSignIn extends SignInStates {}
class SuccessSignIn extends SignInStates {}
class ErrorSignIn extends SignInStates {}


class LeadingResetPassword extends SignInStates {}
class SuccessResetPassword extends SignInStates {}
class ErrorResetPassword extends SignInStates {}


class LeadingCheckTheNumberCode extends SignInStates {}
class SuccessCheckTheNumberCode extends SignInStates {}
class ErrorCheckTheNumberCode extends SignInStates{}