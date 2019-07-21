import { Flex, Button } from '@artsy/palette'
import React from "react"
import AuthService from '../services/authService'
import { Link } from 'react-router-dom';

interface State {
  isLoggedIn: boolean
}

export default class MyAccount extends React.Component<{}, State>{
  authService: AuthService = new AuthService()

  public constructor(props: {}, context: any) {
    super(props, context)
    let token = this.authService.getToken()
    this.state = { isLoggedIn: token !== null }
  }

  public render(){
    const { isLoggedIn } = this.state
    return (
      <>
        {isLoggedIn && <Button size="small" onClick={this.logout}> Logout </Button>}
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

  private logout(){
    this.authService.logout()
    this.setState({isLoggedIn: false})
  }
}