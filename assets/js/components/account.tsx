import { Flex, Button } from '@artsy/palette'
import React, { useState } from "react"
import AuthService from '../services/authService'
import { Link } from 'react-router-dom';
import { SignUp } from '../pages/signup';
import Login from '../pages/login';

export const Account = () => {
  const authService = new AuthService()
  const [isLoggedIn, setIsLoggedIn] = useState(authService.getToken() !== null)
  const [signUp, setSignUp] = useState(false)
  const [login, setLogin] = useState(false)
  return (
    <>
      {isLoggedIn &&
        <Flex flexDirection="row" justifyContent="space-between" width={150} mt={0} mb={0}>
          <Link to="/me"><Button size="small">Me</Button></Link>
          <Button size="small" variant="secondaryOutline" onClick={() => { authService.logout(); setIsLoggedIn(false) }}>Logout</Button>
        </Flex>
      }
      {!isLoggedIn &&
        <Flex flexDirection="row" justifyContent="space-between" width={150} mt={0} mb={0}>
          <Button variant="secondaryOutline" size="small" onClick={() => setLogin(true)}>Login</Button>
          <Button size="small" onClick={() => setSignUp(true)}>SignUp</Button>
        </Flex>}
      {signUp && <SignUp/>}
      {login && <Login/>}
    </>
  )
}
