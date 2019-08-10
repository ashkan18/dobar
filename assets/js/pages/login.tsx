import * as React from "react"
import { Button, Input, Join, Spacer, Box, Spinner } from "@artsy/palette"
import { Link } from 'react-router-dom';
import AuthService from "../services/authService";
import Header from "../components/header";
import { Redirect } from "react-router";
import { useMutation } from '@apollo/react-hooks';
import gql from "graphql-tag";

interface State {
  username: string
  password: string
  loggedIn: boolean
  error?: string
}

const LOGIN = gql`
  mutation Login($username: String!, $password: String!) {
    login(username: $username, password: $password) {
      token
    }
  }
`;


export default class Login extends React.Component<{}, State>{
  authService: AuthService = new AuthService;
  public constructor(props: {}, context: any) {
    super(props, context)
    this.state = { loggedIn: false, username: "", password: "" }
  }

  public render(){
    let input;
    const [login, { data, loading, error }] = useMutation(LOGIN)
    if (data.token) {
      (new AuthService).setToken(data.token)
      return <Redirect to={'/'}/>
    } else if (loading) {
      return <Spinner />
    }
    return(
      <>
        <Header noLogin={true}/>
        <Box m={3} mt={6}>
          <Join separator={<Spacer m={1} />}>
            { error && <> {error} </> }
            <Input onChange={e => this.setUsername(e.currentTarget.value)} placeholder="Email" value={this.state.username}/>
            <Input onChange={e => this.setPassword(e.currentTarget.value)} placeholder="Password" value={this.state.password} type="password"/>
            <Button size="medium" onClick={ _e => login({variables: {username: this.state.username, password: this.state.password}}) }>Login</Button>
            <>Don't have an account? click <Link to={'/signup'}>here</Link></>
          </Join>
        </Box>
      </>
    )
  }

  private setUsername(username: string) {
    this.setState({username})
  }
  private setPassword(password: string) {
    this.setState({password})
  }
}
