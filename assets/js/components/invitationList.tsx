import * as React from "react"
import { Flex, Sans, Separator, BorderBox, Image } from "@artsy/palette"
import { randomFromList } from "../util"

interface InvitationProps {
  invitation: any
  host: boolean
}

export const Invitation = (props: InvitationProps) => {
  const {invitation, host} = props
  return(
    <Flex flexDirection="column" mt={2}>
      <Sans size={2}>{host ? invitation.guestEmail : invitation.host.name} - {invitation.status}</Sans>
    </Flex>
  )
}

interface InvitationListProps {
  invitations: any
  title: string
}
export const InvitationList = (props: InvitationListProps) => {
  const {invitations, title} = props
  if (invitations) {
    const invitationItems = Object.keys(invitations).map(place_id => {
        const place = invitations[place_id][0].place
        return(
          <div key={place_id}>
            <Sans size={5} mt={2}>{title}</Sans>
            <Separator width={70}/>
            <BorderBox flexDirection={"column"}>
              <Flex flexDirection="row">
                <Sans size={4} mt={1}>{place.name}</Sans>
                {place.images && place.images.length > 0 && <Image src={randomFromList(place.images).urls.thumb} lazyLoad={true}/> }
              </Flex>
              <Separator width={50}/>
              {invitations[place_id].map( i => <Invitation invitation={i} host key={i.id}/>)}
            </BorderBox>
          </div>
        )
        }
      )
    return(
      <>
        {invitationItems}
      </>
    )
  } else {
    return(
    <>
      <Sans size={5} mt={2}>{title}</Sans>
      <Separator width={70}/>
      <Sans size={3} mt={1}>Not much going on here at the moment.</Sans>
    </>
    )
  }
}
