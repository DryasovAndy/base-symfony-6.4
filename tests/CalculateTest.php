<?php

declare(strict_types=1);

namespace App\Tests;

use PHPUnit\Framework\TestCase;

class CalculateTest extends TestCase
{
    public function testCalculate(): void
    {
        self::assertSame(2, 1 + 1);
    }
}