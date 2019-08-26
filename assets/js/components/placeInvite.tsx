import * as React from "react"
import { Spinner, Flex, Sans, Input, Button } from "@artsy/palette"

import gql from "graphql-tag";
import { useMutation } from "@apollo/react-hooks";
import { useState } from "react";

interface Props {
  place: any
}

const PLACE_INVITE = gql`
  mutation InviteToPlace($placeId: ID, $guestEmails: [String!]) {
    inviteToPlace(placeId: $placeId, guestEmails: $guestEmails) {
      id
    }
  }
`

export const PlaceInvite = (props: Props) => {
  const {place} = props
  const [guestEmails, setGuestEmails] = useState([""])
  const [inviteToPlaceMutation, { loading, error, called }] = useMutation(PLACE_INVITE)
  const addEmail = (email: string) => {
    setGuestEmails(guestEmails.concat([email]))
  }
  const setEmail = (index: number, email: string) => {
    guestEmails[index] = email
    setGuestEmails(guestEmails)
  }
  return(
    <Flex flexDirection="column" justifyContent="space-between">
      <Sans size={5} mb={2}>Please fill list of emails for people you want to invite to {place.name}?</Sans>
      {guestEmails.map( (ge, index) => <Input type="email" onChange={e =>  setEmail(index, e.currentTarget.value)}/>)}
      <Button onClick={ _e => addEmail("") } mt={2}>Add</Button>
      <Button onClick={ _e => inviteToPlaceMutation({variables:{placeId: place.id, guestEmails: guestEmails}}) } mt={2}>Invite</Button>
    </Flex>
  )
}
