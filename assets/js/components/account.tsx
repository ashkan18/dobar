import { Flex, Button } from '@artsy/palette'
import React, { useState } from "react"
import AuthService from '../services/authService'
import { Link } from 'react-router-dom';

export const Account = () => {
  const authService = new AuthService()
  const [isLoggedIn, setIsLoggedIn] = useState(authService.getToken() !== null)
  return (
    <>
      {isLoggedIn && <Button size="small" onClick={() => { authService.logout(); setIsLoggedIn(false) }}> Logout </Button>}
      {!isLoggedIn &&
        <Flex flexDirection="row" justifyContent="space-between" width={150} mt={0} mb={0}>
          <Link to={'/login'}>
            <Button variant="secondaryOutline" size="small">Login</Button>
          </Link>
          <Link to={'/signup'}>
            <Button size="small">SignUp</Button>
          </Link>
        </Flex>}
    </>
  )
}
