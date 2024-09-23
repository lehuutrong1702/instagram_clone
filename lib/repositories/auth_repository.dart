

mixin AuthRepository{
  Future signUpWithEmailPassword(String email, String password) ;
  Future signInWithEmailPassword(String email, String password);
}