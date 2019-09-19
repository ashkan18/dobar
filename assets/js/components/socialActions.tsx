import * as React from "react"
import { Spinner, Flex, HeartFillIcon, MessageIcon, Modal } from "@artsy/palette"

import gql from "graphql-tag";
import { useMutation } from "@apollo/react-hooks";
import { useState } from "react";
import { PlaceInvite } from "../components/placeInvite";

interface Props {
  place: any
}

const ADD_TO_LIST_MUTATION = gql`
  mutation AddToList($placeId: ID!, $listType: String!){
    addToList(placeId: $placeId, listType: $listType){
      id
    }
  }
`


export const SocialActions = (props: Props) => {
  const {place} = props
  const {myLists} = place
  const alreadyLiked = myLists.some(l => l.listType === "planning_to_go")
  console.log(myLists)
  console.log(myLists.some(l => l.listType === "planning_to_go"))
  const [addToListMutation, { loading, error }] = useMutation(ADD_TO_LIST_MUTATION)
  const [showInvites, setShowInvites] = useState(false)
  if (loading) return(<Spinner />)
  return(
    <>
      <Flex flexDirection="row" justifyContent="space-between" m="auto" mt={1} mb={2} >
        <HeartFillIcon width={30} height={30} style={{cursor: "pointer"}} onClick={(e) => addToListMutation({variables: {placeId: place.id, listType: "planning_to_go"}})} fill={ alreadyLiked ? 'black100' : 'black30'}/>
        <MessageIcon width={30} height={30} style={{cursor: "pointer"}} onClick={ _e => setShowInvites(true) }/>
      </Flex>
      <Modal
          title="Plan a visit"
          hasLogo={false}
          isWide
          show={showInvites}
          onClose={() => setShowInvites(false)}
        >
          <PlaceInvite place={place}/>
      </Modal>
    </>
  )
}
