<?php

namespace AppBundle\Domain\Order\Event;

use AppBundle\Domain\Order\DomainEvent;
use AppBundle\Domain\Order\Event;
use AppBundle\Sylius\Order\OrderInterface;

class OrderDelayed extends Event implements DomainEvent
{
    private $delay;

    public static function messageName()
    {
        return 'order:delayed';
    }

    public function __construct(OrderInterface $order, $delay)
    {
        parent::__construct($order);

        $this->delay = $delay;
    }

    public function getDelay()
    {
        return $this->delay;
    }

    public function toPayload()
    {
        $payload = parent::toPayload();

        return array_merge($payload, [
            'delay' => $this->delay,
        ]);
    }
}
