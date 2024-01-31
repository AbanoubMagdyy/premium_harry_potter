abstract class ProfileStates{}

class InitialState extends ProfileStates{}

class LeadingUpdateProfileListNote extends ProfileStates {}
class SuccessUpdateProfileListNote extends ProfileStates {}
class ErrorUpdateProfileListNote extends ProfileStates {}


class LeadingGetProfileListNotes extends ProfileStates {}
class SuccessGetProfileListNotes extends ProfileStates {}
class ErrorGetProfileListNotes extends ProfileStates {}