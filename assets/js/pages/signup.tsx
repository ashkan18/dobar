import * as React from "react"
import { Button, Input, Join, Spacer, Spinner, Modal, Sans } from "@artsy/palette"
import AuthService from "../services/authService"
import gql from "graphql-tag";
import { useState } from "react";
import { useMutation } from "@apollo/react-hooks";
import { Onboarding } from "../components/onboarding";

const SIGNUP_MUTATION = gql`
  mutation signup($username: String!, $password: String!, $passwordConfirmation: String!, $name: String!, $email: String!){
    signup(username: $username, password: $password, passwordConfirmation: $passwordConfirmation, name: $name, email: $email){
      token
    }
  }
`

export const SignUp = () => {
  const authService = new AuthService()
  const [username, setUserName] = useState("")
  const [password, setPassword] = useState("")
  const [passwordConfirmation, setPasswordConfirmation] = useState("")
  const [name, setName] = useState("")
  const [email, setEmail] = useState("")
  const [showModal, setShowModal] = useState(true)
  const [signUp, { data, loading, error }] = useMutation(SIGNUP_MUTATION)
  const [onboarding, setOnboarding] = useState(false)
  const finishOnboarding = () => {
    window.location.reload()
    setShowModal(false)
    return(<Spinner/>)
  }

  const renderSignUp = () => {
    return(
      <Modal
        title="Sign up"
        show={showModal}
        isWide
        onClose={() => setShowModal(false)}
        >
          {!onboarding &&
            <Join separator={<Spacer m={0}/>}>
              {error && <Sans size={4}> Username taken or passwords didn't match. Please try again.</Sans>}
              <Input type="text" onChange={e => setName(e.currentTarget.value)} title="Name" value={name} />
              <Input type="text" onChange={e => setUserName(e.currentTarget.value)} title="Username" value={username} />
              <Input type="email" onChange={e => setEmail(e.currentTarget.value)} title="Email" value={email} />
              <Input type="password" onChange={e => setPassword(e.currentTarget.value)} title="Password" value={password} />
              <Input type="password" onChange={e => setPasswordConfirmation(e.currentTarget.value)} title="Password Confirmation" value={passwordConfirmation} />
              <Button size="medium" onClick={_e => signUp({ variables: { name: name, username: username, email: email, password: password, passwordConfirmation: passwordConfirmation } })} mt={1}>Signup!</Button>
              {loading && <Spinner/>}
            </Join>
          }
          { onboarding &&
            <Onboarding onFinish={() => finishOnboarding()}/>
          }
      </Modal>
    )
  }
  if (data) {
    authService.setToken(data.signup.token)
    setOnboarding(true)
  } else {
    return renderSignUp()
  }
}
