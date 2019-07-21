export default class AuthService {
  TOKEN_KEY = 'id_token'

  setToken = (idToken: string) => {
    // Saves user token to localStorage
    localStorage.setItem(this.TOKEN_KEY, idToken)
  }

  getToken():string|null {
    // Retrieves the user token from localStorage
    return localStorage.getItem(this.TOKEN_KEY)
  }

  logout = () => {
    localStorage.removeItem(this.TOKEN_KEY)
  }
}
