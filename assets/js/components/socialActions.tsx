import * as React from "react"
import { Spinner, Flex, HeartFillIcon, MessageIcon, Modal, Sans, Input, Button, Box, Message, HeartIcon } from "@artsy/palette"

import gql from "graphql-tag";
import { useMutation } from "@apollo/react-hooks";
import { useState } from "react";
import PhotoUpload from "./photoUpload";

interface Props {
  place: any
  me: any
}

const ADD_TO_LIST_MUTATION = gql`
  mutation AddToList($placeId: ID!, $listType: String!){
    addToList(placeId: $placeId, listType: $listType){
      id
    }
  }
`
const PLACE_INVITE = gql`
  mutation InviteToPlace($placeId: ID, $guestEmails: [String!]) {
    inviteToPlace(placeId: $placeId, guestEmails: $guestEmails) {
      id
    }
  }
`


export const SocialActions = (props: Props) => {
  const {place, me} = props
  const {myLists} = place
  const alreadyLiked = myLists && myLists.some(l => l.listType === "planning_to_go")
  const [addToListMutation, { loading: addToListLoading, error: addToListError }] = useMutation(ADD_TO_LIST_MUTATION)
  const [showInvites, setShowInvites] = useState(false)
  const [guestEmails, setGuestEmails] = useState([""])
  const [inviteToPlaceMutation, { data: inviteData, loading: inviteLoading, error: inviteError, called: inviteCalled }] = useMutation(PLACE_INVITE)
  const [showInviteConfirmation, setShowInviteConfirmation] = useState(false)
  const addEmail = (email: string) => {
    setGuestEmails(guestEmails.concat([email]))
  }
  const setEmail = (index: number, email: string) => {
    guestEmails[index] = email
    setGuestEmails(guestEmails)
  }

  const sendInvites = () => {
    inviteToPlaceMutation({variables:{placeId: place.id, guestEmails: guestEmails}})
    setShowInvites(false)
    setShowInviteConfirmation(true)
  }
  if (addToListLoading || inviteLoading) return(<Spinner />)
  return(
    <>
      <Flex flexDirection="row" justifyContent="space-between" m="auto" mt={1} mb={2} >
        <PhotoUpload me={me} place={place}/>
        {alreadyLiked && <HeartFillIcon mr={1} ml={1} width={25} height={25} style={{cursor: "pointer"}} fill='red100'/> }
        {!alreadyLiked && <HeartIcon mr={1} ml={1} width={25} height={25} style={{cursor: "pointer"}} onClick={(e) => addToListMutation({variables: {placeId: place.id, listType: "planning_to_go"}})} /> }
        <MessageIcon mr={1} ml={1} width={30} height={30} style={{cursor: "pointer"}} onClick={ _e => setShowInvites(true) }/>
      </Flex>
      {showInviteConfirmation &&
        <Box>
          <Message>
            <Sans size={4}>Your invite has been sent.</Sans>
          </Message>
        </Box>
      }
      <Modal
        title="Plan a visit"
        hasLogo={false}
        isWide
        show={showInvites}
        onClose={() => setShowInvites(false)}
      >
          <Flex flexDirection="column" justifyContent="space-between">
            <Sans size={5} mb={2}>Please fill list of emails for people you want to invite to {place.name}?</Sans>
            {guestEmails.map( (ge, index) => <Input type="email" key={index} onChange={e =>  setEmail(index, e.currentTarget.value)}/>)}
            <Button onClick={ _e => addEmail("") } mt={2}>Add</Button>
            <Button onClick={ _e =>  sendInvites() } mt={2}>Invite</Button>
          </Flex>
      </Modal>
    </>
  )
}
