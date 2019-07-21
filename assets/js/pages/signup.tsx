import * as React from "react"
import { Button, Input, Join, Spacer, Box, Spinner } from "@artsy/palette"
import AuthService from "../services/authService"
import gql from "graphql-tag";
import Header from "../components/header";
import { Redirect } from "react-router";
import { Mutation } from "react-apollo";

interface State {
  username: string
  email: string
  password: string
  passwordConfirmation: string
  name: string
  loggedIn: boolean
  error?: string
}

export default class Signup extends React.Component<{}, State>{
  authService: AuthService = new AuthService;
  public constructor(props: {}, context: any) {
    super(props, context)
    this.state = { loggedIn: false, name: "", username: "", password: "", passwordConfirmation: "", email: "" }
  }

  signUpMutation = gql`
    mutation createUser($username: String!, $password: String!, $passwordConfirmation: String!, $name: String!, $email: String!){
      createUser(username: $username, password: $password, passwordConfirmation: $passwordConfirmation, name: $name, email: $email){
        token
      }
    }
  `

  public render(){
    return(
      <Mutation mutation={this.signUpMutation}>
        {(signUp, {data, loading, error}) => {
            if (data) {
              this.authService.setToken(data.data.token)
              return(<Redirect to={'/'} />)
            } else if (loading) {
              return <Spinner/>
            } else {
              return (
                <>
                  <Header noLogin={true} />
                  <Box m={3} mt={6}>
                    <Join separator={<Spacer m={1} />}>
                      {error}
                      <Input type="text" onChange={e => this.setName(e.currentTarget.value)} title="Name" value={this.state.name} />
                      <Input type="text" onChange={e => this.setUsername(e.currentTarget.value)} title="Username" value={this.state.username} />
                      <Input type="email" onChange={e => this.setEmail(e.currentTarget.value)} title="Email" value={this.state.email} />
                      <Input type="password" onChange={e => this.setPassword(e.currentTarget.value)} title="Password" value={this.state.password} />
                      <Input type="password" onChange={e => this.setPasswordConfirmation(e.currentTarget.value)} title="Password Confirmation" value={this.state.passwordConfirmation} />
                      <Button size="medium" onClick={_e => signUp({ variables: { name: this.state.name, username: this.state.username, email: this.state.email, password: this.state.password, passwordConfirmation: this.state.passwordConfirmation } })} mt={1}>Signup!</Button>
                    </Join>
                  </Box>
                </>
              )
            }
          }
        }
      </Mutation>
    )
  }

  private setName(name: string) {
    this.setState({name})
  }
  private setUsername(username: string) {
    this.setState({username})
  }
  private setEmail(email: string) {
    this.setState({email})
  }
  private setPassword(password: string) {
    this.setState({password})
  }
  private setPasswordConfirmation(passwordConfirmation: string) {
    this.setState({passwordConfirmation})
  }
}
